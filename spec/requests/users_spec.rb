require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET #index' do
    subject { get(users_path) }
    context 'ユーザーが存在するとき' do
      before { create_list(:user, 3) }
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:ok)
      end
      it 'nameが表示されている' do
        subject
        expect(response.body).to include(*User.pluck(:name))
      end
    end
  end

  describe 'GET #show' do
    subject { get(user_path(user.id)) }
    context 'ユーザーが存在するとき' do
      let(:user) { create(:user) }
      let(:user_id) { user.id }
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:ok)
      end
      it 'nameが表示される' do
        subject
        expect(response.body).to include user.name
      end
      it 'ageが表示される' do
        subject
        expect(response.body).to include user.age.to_s
      end
      it 'emailが表示される' do
        subject
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get(new_user_path)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #create' do
    subject { post(users_path, params: params) }
    context 'パラメータが正常なとき' do
      let(:params) { { user: attribute_for(:user) } }
      it 'returns http success' do
        subject
        expect(response).to have_http_status(302)
      end
      it 'ユーザーが保存される' do
        expect { subject }.to change { User.count }.by(1)
      end
      it '詳細ページにリダイレクトされる' do
        subject
        expect(response).to redirect_to User.last
      end
    end
    context 'パラメータが異常なとき' do
      let(:params) { { user: attribute_for(:user, :invalid) } }
      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(200)
      end
      it 'ユーザーが保存されない' do
        expect { subject }.not_to change(User, :count)
      end
      it '新規投稿ページがリダイレクトされる' do
        subject
        expect(response.body).to include '新規投稿'
      end
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/users/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/users/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/users/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
