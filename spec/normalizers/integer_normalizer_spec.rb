require 'normalizers/integer_normalizer'

describe IntegerNormalizer do
  subject { IntegerNormalizer.instance }

  describe '#normalize_field' do
    it { expect(subject.normalize_field(105)).to eq 105 }
    it { expect(subject.normalize_field('105')).to eq 105 }
    it { expect { subject.normalize_field('abcd') }.to raise_error(NormalizingError)  }
  end

  describe '#normalize_search_query' do
    it { expect(subject.normalize_search_query('105')).to eq 105 }

    it 'returns original query if cannot parse to an integer' do
      expect { subject.normalize_search_query('abcd')}.to raise_error(NormalizingError)
    end
  end
end