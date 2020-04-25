require 'normalizer'

# describe Normalizer do
#   describe 'TEXT_NORMALIZER' do
#     subject { Normalizer::TEXT_NORMALIZER }

#     describe '#normalize' do
#       it 'lower case' do
#         expect(subject.normalize('Armstrong')).to eq 'armstrong'
#       end

#       it 'ascii folding for Latin characters' do
#         expect(subject.normalize('MegaCörp')).to eq 'megacorp'
#       end

#       it 'removes normal punctuations' do
#         expected_normailized = 'its a drama in cocos keeling islands'
#         expect(subject.normalize("It's A Drama in Cocos (Keeling Islands).?!")).to eq expected_normailized
#       end
#     end
#   end

#   describe 'NONCHANGE_NORMALIZER' do
#     subject { Normalizer::NONCHANGE_NORMALIZER }

#     it 'keeps id intact' do
#       expect(subject.normalize('530bc434-9984-4a54-8a74-83433d3da340')).to eq('530bc434-9984-4a54-8a74-83433d3da340')
#     end
#   end

#   describe 'BOOLEAN_NORMALIZER' do

#   end
# end