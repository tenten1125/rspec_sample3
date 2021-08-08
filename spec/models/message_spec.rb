require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'バリデーション' do
    subject { message.valid? }
    context 'データが条件を満たすとき' do
      let(:message) { build(:message) }
      it '保存できる' do
        expect(subject).to eq true
      end
    end
    context 'titleが空のとき' do
      let(:message) { build(:message, title: '') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(message.errors.messages[:title]).to include 'を入力してください'
      end
    end
    context 'titleが51文字以上のとき' do
      let(:message) { build(:message, title: 'a' * 51) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(message.errors.messages[:title]).to include 'は50文字以内で入力してください'
      end
    end
    context 'contextが空のとき' do
      let(:message) { build(:message, context: '') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(message.errors.messages[:context]).to include 'を入力してください'
      end
    end
    context 'contextが2001文字以上のとき' do
      let(:message) { build(:message, context: 'a' * 2001) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(message.errors.messages[:context]).to include 'は2000文字以内で入力してください'
      end
    end
  end
end
