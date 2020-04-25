require 'normalizers/array_normalizer'

describe ArrayNormalizer do
  subject { ArrayNormalizer.new(TextNormalizer.instance) }

  describe '#normalize_field' do
    it 'normalize each element in the array as text' do
      tags = ['South Carolina', 'Indiana', 'New Mexico', 'Nebraska']
      expect(subject.normalize_field(tags)).to eq ['south carolina', 'indiana', 'new mexico', 'nebraska']
    end
  end

  describe '#normalize_search_query' do
    it 'normalize as text' do
      expect(subject.normalize_search_query('South Carolina')).to eq 'south carolina'
    end
  end
end