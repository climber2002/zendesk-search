require 'normalizers/boolean_normalizer'

describe BooleanNormalizer do
  subject { BooleanNormalizer.instance }

  describe '#normalize_field_value' do
    it { expect(subject.normalize_field_value(true)).to eq true }
    it { expect(subject.normalize_field_value('true')).to eq true }
    it { expect(subject.normalize_field_value(false)).to eq false }
    it { expect(subject.normalize_field_value('false')).to eq false }
    it { expect { subject.normalize_field_value('abcd') }.to raise_error(NormalizingError)  }
  end

  describe '#normalize_search_term' do
    it { expect(subject.normalize_search_term('true')).to eq true }
    it { expect(subject.normalize_search_term('false')).to eq false }
    it { expect { subject.normalize_search_term('abcd') }.to raise_error(NormalizingError)  }
  end
end