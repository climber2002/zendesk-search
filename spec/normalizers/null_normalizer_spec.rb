require 'normalizers/null_normalizer'

describe NullNormalizer do
  subject { NullNormalizer.instance }

  describe '#normalize_field_value' do
    it 'does not do normalization' do
      expect(subject.normalize_field_value(105)).to eq 105
      expect(subject.normalize_field_value('abcd')).to eq 'abcd'
    end
  end

  describe '#normalize_search_term' do
    it 'does not do normalization' do
      expect(subject.normalize_search_term('105')).to eq '105'
      expect(subject.normalize_search_term('abcd')).to eq 'abcd'
    end
  end
end