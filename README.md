# Zendesk Search Coding Challange

This is a Ruby solution to Zendesk Search coding challange and it's created by Andy Wang (climber2002@gmail.com)

## Setup and Running

### Project Structure

The project has following sub-folders:
- bin:  contains `zendesk-search` executable
- json: contains the json files for `organizations`, `users` and `tickets` which will be loaded when the app starts
- lib:  contains production code
- spec: contains rspec tests

### Setup

I use Ruby `2.6.3` to create this app but it should work with any version higher than `2.5.0`. The only dependency for this app is the `rspec` gem. If you already have `rspec` installed then all is setup. Otherwise `cd` into project directory and run following command to install `rspec` (All following commands assume the current directory is the project directory),

```bash
bundle install
```

If it throws errors such as `ERROR:  While executing gem ... (Gem::FilePermissionError)`, try to run `sudo bundle install`.

### Run all tests

The project uses `rspec` as the test framework. Just run all specs by running following command,

```bash
rspec
```

### Run the application

To run the application run following command and then follow the instructions,

```
./bin/zendesk-search
```

### Assumptions

The application made following assumptions:

1. When the search result is not empty, values from any related entities will be included in the results. For example, searching tickets will also return the ticket's submitter, assignee and organization. If the related entity can't be found by the related entity id, the application assumes it's dirty data and will print an error message. For example if search `Ticket(_id=bc736a06-eeb0-4271-b4a8-c66f61b5df1f)`, it will print error `Error occured while searching: Id 555 doesn't exist for User` because the ticket's `submitter_id` is `555` but in `users.json` there is no user whose id is 555.

2. The application can search empty values, when the application asks the user to input the search value, if the user just press Enter the application will search empty values. The application assumes that following 3 cases are all empty values:
    - If the field is missing in the json file
    - If the field type is string and the field value is empty string
    - If the field type is an array and the field value is empty array, e.g. empty tags

3. According to the requirement the application only needs to do `full value matching`, which means that when search a field value it will only include the result if the value is fully matched. However for text fields such as `name`, `description` and `tags` the application will ignore cases and punctuations, and also the  special Latin characters such as áèîõü will be converted to corresponding ASCII characters, which means,
    - `megacorp` will find `MegaCorp` and `MegaCörp` and vice versa
    - `a nuisance in cote divoire ivory coast` will find `A Nuisance in Cote D'Ivoire (Ivory Coast)` and vice versa
    - `Don't Worry Be Happy!` will find `dont worry be happy` and vice versa

4. For fields which are array, a value that matches any element in the array will find the entity. For example, search `tags=Oregon` will find the entity whose tag is `['Oregon', 'Arizona', 'Delaware']`.

5. For datetime fields such as `created_at`, the application assumes it's a match if it's the same datetime. For example, `2016-07-28T11:26:16 -09:00` will match `2016-07-28T10:26:16 -10:00` as the two values mean same datetime even though the timezone is different.

## Design and Implementation

In this section I'll explain the main modules and discuss the tradeoffs.

The application is splitted into two main modules: `EntityRepository` and `IndexRepository`, and there are other helper modules such as `FieldsEnricher`. We will explain the modules one by one.

### EntityRepository

As the search result must include all fields of the entities, after we load the entities from json file we must store all the fields somewhere, that's what `EntityRepository` does, which provides APIs to add entity and also fetch entity by id.

#### EntityType and Entity

Initially I thought to create a distinct class for each entity type `Organization`, `User` and `Ticket`, however I found that these entities just stores the fields and don't have much business logic. So I decided to just create a generic `EntityType` and `Entity` class. The `EntityType` defines the name of the entity type and supported fields. And `Entity` objects represent instances of a particular `EntityType`.

#### EntityRepository
The `EntityRespository` is just a repository which stores all entities. Each `EntityType` has its own entity store. And in the entity store the entities are saved in a hash which maps entity id to entity, so the time complexity is `O(1)` when fetch an entity by id.

### IndexRepository

To improve the performance of the search we can't search each entity one by one, otherwise the search response will increase linearly as entities grows. So we use a data structure called `Inverted Index` to improve response time. The `IndexRepository` is a repository which stores a bunch of inverted index.

#### InvertedIndex

The `InvertedIndex` is a data structure which stores mappings from content to entity id. For example, when we add an entity, the entity will not only be added into the `EntityRepository`, but also its all field values will be indexed into some `InvertedIndex`. The main structure in `InvertedIndex` is a hash which maps a value to a set of entity ids. For example, for the User's `role` field, if it maps the value `admin` to user ids `1` and `3`, then when the user searches `admin` against `role` field, it takes time complexity `O(1)` to find the two entity ids whose role field is `admin`.

Each `InvertedIndex` object will manage the inverted index for a particular field of an entity type. And `EntityIndex` manages the inverted index for all fields of an entity type (discussed later).

The `InvertedIndex` mainly has two instance methods,
- index: which is to index the terms for an entity id
- search: which is to search the entity ids based on the search term

**Empty value:** Each `InvertedIndex` maintains a special mapping whose key is `_empty_`, this is to store the entity ids whose value is empty, as this coding challenge requires that it should be able to search empty values. When search a term, if the term is empty, then the entity ids whose value is empty will be returned.

#### Normalizers

Before we index field value of an entity, the field value should be `normalized` first, for example, if it's text, we might want to lowercase the text and remove punctuations, if it's datetime string, we might want to normalize it into a DateTime object so we can perform range search later. That's what normalizers do.

The application provides a bunch of normalizers in the `lib/normalizers/` folder. Each normalizer must implement two methods,

- normalize_field_value: This is called when index an entity, the field values will be normalized before indexed in `InvertedIndex`. The field value is not necessarily a string, it could be an integer or boolean value that is read from json files. If the value can't be normalized it could throw `NormalizingError` exception, this can help us to validate that the entity conforms to the schema when we add an entity.
- normalize_search_term: When the user inputs a search term, the search term must also be normalized in the same way, otherwise there is no way we can find the result. The difference is that the user usually passes search term as a string, and we might need to normalize it into an integer or datetime before we search in `InvertedIndex`. If the search term can't be normalized we just return empty result as there is no way we can match any entity.

For the above two methods, if the value to be normalized is empty then it should return `nil` so the inverted index will index them as empty values, and also search as empty values.

The application provides the following normalizers:
- NullNormalizer: This normalizer does not do any normalization. For example for the `_id` of Tickets which is UUID string we should keep the original field value
- BooleanNormalizer: Normalize the value into a boolean, such as true or false
- IntegerNormalizer: Normalize the value into an integer
- DateTimeNormalizer: Normalize the value into a DateTime object
- TextNormalizer: Lowercase the text, remove punctuations and replace special Latin characters with corresponding ASCII characters
- ArrayNormalizer: Normalize an array, can pass a `element_normalizer` to normalize the elements in the array.

**Tokenize**: Usually after normalizing and before add the normalized value into the inverted index, there is another step called tokenizing, which is to split the normalized value into tokens. For example, `Francisca Rasmussen` can be tokenized into `francisca` and `rasmussen` so the user can get the result if he searches either `Francisca` or `Rasmussen`. This application doesn't do tokenizing currently since it only requires full value match. But in `EntityIndex#tokenize` method if provides an extension point where we can add tokenizing later.

#### EntityIndex

The `EntityIndex` class is to manage all `InvertedIndex` for an entity type. So for each searchable field there will be an `InvertedIndex` instance. The `EntityIndex` maintains a hash instance variable `@field_normalizers` which acts like a schema for indexing. The schema maps from the `field_name` to its corresponding normalizer. So when do indexing and search we know how to normalizing for each field in its own way.

It provides the following instance methods mainly:

- index: This is to index an entity. Each searchable field will be fetched from the entity and then indexed into that field's `InvertedIndex`.
- search: To search the entity ids given a field name and a search term.

#### IndexRepository

The `IndexRepository` class just maintains the `EntityIndex` for each entity type.

### SearchManager

The `SearchManager` is like the facade of the application which manages one `EntityRepository` and one `IndexRepository`. When add an entity it will add the entity into `entity_repository` and then index the entity in `index_repository`. This small app just does the two steps in a synchronous way. For a real system we can improve the indexing performance by indexing asynchronously, which means after add an entity to the `entity_repository` then send an event asynchronously to `index_repository` to do indexing.

### FieldsEnricher

The application requires that when return the search results it should also include fields from the related entities. To implement this we use `FieldsEnricher`, there is a `FieldsEnricher` class for each entity type since each entity type needs to be enriched differently. The source code for `FieldsEnricher` is in `lib/fields_enrichers/` subfolder. It get the related entities by calling `SearchManager` since SearchManager has all the information. And also the performance should be fast enough since whether we fetch the the related entities by id or search against id the time complexity is always *roughly* `O(1)`.

One problem for this solution is that we can't identify dirty data when add entities. For example if add a ticket whose submitter_id doesn't exist, we can't prevent the invalid data to be saved in repository, we can only identify it when doing search and find the related_id doesn't exist.

### Runner and Command

The entrypoint of this app is the `Runner` class, which firstly creates a `SearchManager` instance from the json files, and then just accept user input from console and transform the input into corresponding command and then execute it. Currently we have two `Command` classes in `lib/commands/` folder,

- SearchFieldCommand: This is to do search
- ListSearchableFieldsCommand: This is to list searchable fields for each entity type.
