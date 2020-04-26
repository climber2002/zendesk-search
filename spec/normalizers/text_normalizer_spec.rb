require 'normalizers/text_normalizer'

describe TextNormalizer do
  subject { described_class.instance }

  describe '#normalize_field_value' do
    it { expect(subject.normalize_field_value(nil)).to be_nil }

    it 'lower case' do
      expect(subject.normalize_field_value('Armstrong')).to eq 'armstrong'
    end

    it 'ascii folding for Latin characters' do
      expect(subject.normalize_field_value('MegaCörp')).to eq 'megacorp'
    end

    it 'removes normal punctuations' do
      expected_normailized = 'its a drama in cocos keeling islands'
      expect(subject.normalize_field_value("It's A Drama in Cocos (Keeling Islands).?!")).to eq expected_normailized
    end
  end

  describe '#normalize_search_term' do
    it 'returns nil if search_query is empty' do
      expect(subject.normalize_search_term(nil)).to eq nil
      expect(subject.normalize_search_term('')).to eq nil
    end

    it 'lower case' do
      expect(subject.normalize_search_term('Armstrong')).to eq 'armstrong'
    end

    it 'ascii folding for Latin characters' do
      expect(subject.normalize_search_term('MegaCörp')).to eq 'megacorp'
    end

    it 'removes normal punctuations' do
      expected_normailized = 'its a drama in cocos keeling islands'
      expect(subject.normalize_search_term("It's A Drama in Cocos (Keeling Islands).?!")).to eq expected_normailized
    end
  end
end