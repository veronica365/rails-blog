require 'swagger_helper'

RSpec.describe 'user', type: :request do
  path '/users.json' do
    get 'view all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 photo: { type: :string },
                 post_counter: { type: :integer },
                 email: { type: :string },
                 role: { type: :string },
                 bio: { type: :string },
                 content: { type: :string }
               },
               required: %w[id email bio]

        let(:id) { User.create(name: 'foo', email: 'email@foo.com', bio: 'test bio').id }
        run_test!
      end
    end
  end

  path '/users/{user_id}.json' do
    get 'Retrieves a user' do
      tags 'Users', 'Single user'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 photo: { type: :string },
                 post_counter: { type: :integer },
                 email: { type: :string },
                 role: { type: :string },
                 bio: { type: :string },
                 content: { type: :string }
               },
               required: %w[id email bio]

        let(:id) { User.create(name: 'foo', email: 'email@foo.com', bio: 'test bio').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        run_test!
      end
    end
  end
end
