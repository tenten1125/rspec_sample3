require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { user.valid? }

    context 'データが条件を満たす時' do
      let(:user) { build(:user) }
      it '保存できる' do
        expect(subject).to eq true
      end
    end
    context 'nameが31文字以上のとき' do
      let(:user) { build(:user, name: 'a' * 31) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:name]).to include 'は30文字以内で入力してください'
      end
    end
    context 'nameが空のとき' do
      let(:user) { build(:user, name: '') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:name]).to include 'を入力してください'
      end
    end
    context 'ageが空のとき' do
      let(:user) { build(:user, age: '') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:age]).to include 'を入力してください'
      end
    end
    context 'ageが文字列のとき' do
      let(:user) { build(:user, age: '32') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:age]).to include 'は数値で入力してください'
      end
    end
    context 'ageが151以上のとき' do
      let(:user) { build(:user, age: 151) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:age]).to include 'は一覧にありません'
      end
    end
    context 'ageが負の数のとき' do
      let(:user) { build(:user, age: -1) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:age]).to include 'は一覧にありません'
      end
    end
    context 'emailが空のとき' do
      let(:user) { build(:user, email: '') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include 'を入力してください'
      end
    end
    context 'emailが256文字以上のとき' do
      let(:user) { build(:user, email: 'a' * 256) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include 'は255文字以内で入力してください'
      end
    end
    context 'emailがすでに存在するとき' do
      before { create(:user, email: 'test@example.com') }
      let(:user) { build(:user, email: 'test@example.com') }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include 'はすでに存在します'
      end
    end
    context 'emailがアルファベット・英数字のみのとき' do
      let(:user) { build(:user, email: Faker::Lorem.characters(number: 16)) }
      it 'エラーが発生する' do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include 'は不正な値です'
      end
    end
  end

  describe 'ユーザーが削除されたとき' do
    subject { user.destroy }

    let(:user) { create(:user) }
    before do
      create_list(:message, 2, user: user)
      create(:message)
    end
    it 'そのユーザーのメッセージも削除される' do
      expect { subject }.to change { user.messages.count }.by(-2)
    end
  end
end
