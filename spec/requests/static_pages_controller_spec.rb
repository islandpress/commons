require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do
  describe 'GET #home' do
    def perform_request
      get '/'
    end

    let(:counts) do
      {
        0 => 20,
        1 => 20,
        2 => 20,
        3 => 20,
        4 => 20,
        5 => 20,
        6 => 20,
        7 => 20,
        8 => 20,
        9 => 20,
        10 => 20,
        11 => 20,
        12 => 20,
        13 => 20,
        14 => 20
      }
    end

    before do
      20.times do
        create(:network)
        create(:article)
        create(:audio)
        create(:book)
        create(:course)
        create(:dataset)
        create(:image)
        create(:post)
        create(:profile)
        create(:report)
        create(:slide)
        create(:software)
        create(:syllabus)
        create(:url)
        create(:video)
      end
      perform_request
    end

    it 'responds with success' do
      expect(response).to be_success
    end

    it 'assigns 10 random networks' do
      expect(assigns(:networks).count).to eq(10)
    end

    %i(article book report audio course dataset syllabus video slide post software).
      each do |resource_type|

      it "assigns 6 random #{resource_type}" do
        expect(assigns(resource_type.to_s.pluralize).count).to eq(6)
      end
    end

    it 'assigns resource count by resource type' do
      expect(assigns(:counts)).to eq(counts)
    end
  end
end
