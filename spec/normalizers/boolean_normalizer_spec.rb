require 'normalizers/boolean_normalizer'

describe BooleanNormalizer do
  subject { BooleanNormalizer.instance }

  describe '#normalize_field' do
    it { expect(subject.normalize_field(true)).to eq true }
    it { expect(subject.normalize_field('true')).to eq true }
    it { expect(subject.normalize_field(false)).to eq false }
    it { expect(subject.normalize_field('false')).to eq false }
    it { expect { subject.normalize_field('abcd') }.to raise_error(NormalizingError)  }
  end

  describe '#normalize_search_query' do
    it { expect(subject.normalize_search_query('true')).to eq true }
    it { expect(subject.normalize_search_query('false')).to eq false }
    it { expect { subject.normalize_search_query('abcd') }.to raise_error(NormalizingError)  }
  end
end