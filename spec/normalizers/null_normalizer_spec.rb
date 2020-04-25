require 'normalizers/null_normalizer'

describe NullNormalizer do
  subject { NullNormalizer.instance }

  describe '#normalize_field' do
    it 'does not do normalization' do
      expect(subject.normalize_field(105)).to eq 105
      expect(subject.normalize_field('abcd')).to eq 'abcd'
    end
  end

  describe '#normalize_search_query' do
    it 'does not do normalization' do
      expect(subject.normalize_field('105')).to eq '105'
      expect(subject.normalize_field('abcd')).to eq 'abcd'
    end
  end
end