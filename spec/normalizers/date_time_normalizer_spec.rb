require 'date'
require 'normalizers/date_time_normalizer'

describe DateTimeNormalizer do
  subject { DateTimeNormalizer.instance }

  describe '#normalize_field' do
    it 'parse field into DateTime if value is valid' do
      expect(subject.normalize_field('2016-06-07T02:50:27 -10:00')).to eq DateTime.new(2016, 6, 7, 2, 50, 27, '-10:00')
    end

    it 'raise NormalizingError if the datetime is not parsable' do
      expect { subject.normalize_field('abcd') }.to raise_error(NormalizingError)
    end
  end
end