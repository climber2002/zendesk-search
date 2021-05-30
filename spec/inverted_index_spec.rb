require 'inverted_index'

describe InvertedIndex do
  subject { described_class.new }

  describe '#index' do
    context 'when index an array of string and entity ids are integer' do
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

      it 'should return empty result if no entity field matches the serach term' do
        expect(subject.search('nonexist')).to eq []
      end
    end

    context 'when the terms are booleans and entity ids are string' do
      let(:empty_boolean) { nil }
      let(:true_boolean) { true }
      let(:false_boolean) { false }

      before do
        subject.index(empty_boolean, '200')
        subject.index(true_boolean, '201')
        subject.index(false_boolean, '202')
        subject.index(true_boolean, '203')
      end

      it 'can search against true' do
        expect(subject.search(true)).to eq ['201', '203']
      end
      
      it 'can search against false' do
        expect(subject.search(false)).to eq ['202']
      end

      it 'can search against empty' do
        expect(subject.search(nil)).to eq ['200']
      end
    end

    context 'when the terms are string and entity ids are string' do
      let(:empty) { nil }
      let(:string1) { 'string1' }
      let(:string2) { 'string2' }

      before do
        subject.index(empty, '200')
        subject.index(string2, '201')
        subject.index(string1, '202')
        subject.index(string2, '203')
      end

      it 'can search against string terms' do
        expect(subject.search(string2)).to eq ['201', '203']
        expect(subject.search(string1)).to eq ['202']
      end

      it 'can search against empty' do
        expect(subject.search(nil)).to eq ['200']
      end
    end
  end
end