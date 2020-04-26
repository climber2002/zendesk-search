require 'normalizers/integer_normalizer'

describe IntegerNormalizer do
  subject { IntegerNormalizer.instance }

  describe '#normalize_field_value' do
    it { expect(subject.normalize_field_value(105)).to eq 105 }
    it { expect(subject.normalize_field_value('105')).to eq 105 }
    it { expect { subject.normalize_field_value('abcd') }.to raise_error(NormalizingError)  }
  end

  describe '#normalize_search_term' do
    it { expect(subject.normalize_search_term('105')).to eq 105 }

    it 'returns original query if cannot parse to an integer' do
      expect { subject.normalize_search_term('abcd')}.to raise_error(NormalizingError)
    end
  end
end