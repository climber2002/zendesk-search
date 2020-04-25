## 
# The EntityIndex maintains the inverted indices for a particular EntityType. Each
# searchable field has its own inverted index. When create an EntityIndex instance, 
# it should be passed a list of normalizers so each searchable field has its own normalizer,
# check the comments in normalizer to find out why we need normalizer
class EntityIndex
  def initialize(field_normalizers)
    @field_normalizers = field_normalizers
  end


end