require 'inverted_index'

describe InvertedIndex do
  subject { described_class.new }

  describe '#index' do
    context 'when index an array of string' do
      let(:empty_tags) { [] }
      let(:tag_terms1) { ['springville', 'sutton', 'diaperville'] }
      let(:tag_terms2) { ['foxworth', 'sutton'] }

      before do
        subject.index(empty_tags, 100)
        subject.index(tag_terms1, 101)
        subject.index(tag_terms2, 102)
      end

      it 'should return the corresponding id when the search term matches one entity' do
        expect(subject.search('diaperville')).to eq [101]
      end

      it 'should return all correponding ids when the search term matches multiple entities' do
        expect(subject.search('sutton')).to eq [101, 102]
      end

      it 'should return the ids whose tags are empty when search against nil' do
        expect(subject.search(nil)).to eq [100]
      end
    end
  end
end