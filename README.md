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

3. Following the requirement the application just does `full value matching`, which means that when search a field value it will only include the result if the value is fully matched. However for text fields such as `name`, `description` and `tags` the application will ignore cases and punctuations, and also the  special Latin characters such as áèîõü will be converted to corresponding ASCII characters, which means,
    - `megacorp` will find `MegaCorp` and `MegaCörp`
    - `a nuisance in cote divoire ivory coast` will find `A Nuisance in Cote D'Ivoire (Ivory Coast)`
    - `A Nuisance in Cote D'Ivoire Ivory Coast` will find `A Nuisance in Cote D'Ivoire (Ivory Coast)`

4. For fields which are array, a value that matches any element in the array will find the entity. For example, search `tags=Oregon` will find the entity whose tag is `['Oregon', 'Arizona', 'Delaware']`.

5. For datetime fields such as `created_at`, the application assumes it's a match if it's the same datetime. For example, `2016-07-28T11:26:16 -09:00` will match `2016-07-28T10:26:16 -10:00` as the two values mean same datetime even though the timezone is different.

