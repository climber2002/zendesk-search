require 'normalizers/text_normalizer'

describe TextNormalizer do
  subject { described_class.instance }

  describe '#normalize_field' do
    it 'lower case' do
      expect(subject.normalize_field('Armstrong')).to eq 'armstrong'
    end

    it 'ascii folding for Latin characters' do
      expect(subject.normalize_field('MegaCörp')).to eq 'megacorp'
    end

    it 'removes normal punctuations' do
      expected_normailized = 'its a drama in cocos keeling islands'
      expect(subject.normalize_field("It's A Drama in Cocos (Keeling Islands).?!")).to eq expected_normailized
    end
  end

  describe '#normalize_search_query' do
    it 'returns nil if search_query is empty' do
      expect(subject.normalize_search_query(nil)).to eq nil
      expect(subject.normalize_search_query('')).to eq nil
    end

    it 'lower case' do
      expect(subject.normalize_search_query('Armstrong')).to eq 'armstrong'
    end

    it 'ascii folding for Latin characters' do
      expect(subject.normalize_search_query('MegaCörp')).to eq 'megacorp'
    end

    it 'removes normal punctuations' do
      expected_normailized = 'its a drama in cocos keeling islands'
      expect(subject.normalize_search_query("It's A Drama in Cocos (Keeling Islands).?!")).to eq expected_normailized
    end
  end
end