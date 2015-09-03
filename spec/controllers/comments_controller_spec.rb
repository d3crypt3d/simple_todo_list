require 'rails_helper'

RSpec.describe API::CommentsController do
    describe 'GET #index' do
        context 'commen case' do
            it 'has status 200 and JSON content type'
            it 'returns a proper collection'
        end

        context 'when a wrong format is requested' do
            it 'has status 406 and JSON content type'
        end
    end

    describe 'GET #show' do
        context 'common case' do
            it 'has status 200 and JSON content type'
        end
        
        context 'when a resource is not found' do
            it 'has status 404 and JSON content type'
        end

        context 'when a wrong format is requested' do
            it 'has status 406 and JSON content type'
        end
    end

    describe 'POST #create' do
        context 'with valid attributes' do
            it 'has status 201 and JSON content type'
        end

        context 'with invalid attributes' do
            it 'has status 422 and JSON content type'
        end
        
        context 'when a wrong format is requested' do
            it 'has status 406 and JSON content type'
            it 'does not creates a new comment'
        end
    end

    describe 'PATCH #update' do
        context 'with valid attributes' do
            it 'has status 200 and JSON content type'
            it 'updates a comment'
        end

        context 'with invalid attributes' do
            it 'has status 422 and JSON content type'
        end

        context 'when a wrong format is requested' do
            it 'has status 406 and JSON content type'
            it 'does not updates a comment'
        end
    end

    describe 'DELETE #destroy' do
        context 'with a valid id' do
            it 'has status 204'
            it 'deletes a task'
        end
        
        context 'when a resourse is not found' do
            it 'has status 404 and JSON content type'
        end

        context 'when a wrong format is requested' do
            it 'has status 406 and JSON content type'
            it 'does not delete a task'
        end
    end
end
