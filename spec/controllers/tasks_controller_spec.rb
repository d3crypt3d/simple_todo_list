require 'rails_helper'

RSpec.describe API::TasksController do
    describe 'GET #index' do
        context 'common case' do
            it 'has 200 status and returns a collection of tasks in JSON format'
        end

        context 'when a wrong format is requested' do
            it 'has 406 status'
        end
    end

    describe 'GET #show' do
        context 'common case' do
            it 'returns a tasks in JSON format'
            it 'has 200 status'
        end

        context 'when a resource is not found' do
            it 'has 404 status'
        end

        context 'when a wrong format is requested' do
            it 'has 406 status'
        end
    end
            
    describe 'POST #create' do
        context 'with valid attributes' do
            it 'has 201 status and returns a resource in JSON format'
        end

        context 'with invalid attributes' do
            it 'has 422 status'
        end
        
        context 'when a wrong format is requested' do
            it 'has 406 status'
            it 'does not create a new task'
        end
    end

    describe 'PATCH #update' do
        context 'with valid attributes' do
            it 'has 201 status and returns a resource in JSON format'
        end

        context 'with invalid attributes' do
            it 'has 422 status'
        end
        
        context 'when a wrong format is requested' do
            it 'has 406 status'
            it 'does not change an attribute'
        end
    end
    
    describe 'DELETE #destroy' do
        context 'with a valid id' do
            it 'has 204 status'
        end

        context 'when a resourse is not found' do
            it 'has 404 status'
        end

        context 'when a wrong format is requested' do
            it 'has 406 status'
            it 'does not delete the task'
        end
    end
end
