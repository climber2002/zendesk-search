require 'normalizers/array_normalizer'

describe ArrayNormalizer do
  subject { ArrayNormalizer.new(TextNormalizer.instance) }

  describe '#normalize_field_value' do
    it 'normalize each element in the array as text' do
      tags = ['South Carolina', 'Indiana', 'New Mexico', 'Nebraska']
      expect(subject.normalize_field_value(tags)).to eq ['south carolina', 'indiana', 'new mexico', 'nebraska']
    end

    it 'thinks nil is empty value' do
      expect(subject.normalize_field_value(nil)).to be_nil
    end
    it 'thinks empty array is empty value' do
      expect(subject.normalize_field_value([])).to be_nil
    end
  end

  describe '#normalize_search_term' do
    it 'normalize as text' do
      expect(subject.normalize_search_term('South Carolina')).to eq 'south carolina'
    end
  end
end