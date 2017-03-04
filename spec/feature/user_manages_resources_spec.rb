# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Managing resources" do
  scenario "users can list resources" do
    user = feature_login
    resource = create(:resource, user: user)

    click_link "My Resources"
    expect(find("h1")).to have_content("My Resources")
    expect(page).to have_text(resource.title)
  end

  scenario "users can access original document if URL is provided" do
    user = feature_login
    create(:resource, user: user, url: "http://example.com")

    click_link "My Resources"
    expect(find_link("View Original Document")[:href]).to eq("https://via.hypothes.is/http://example.com")
    expect(find_link("View Original Document")[:target]).to eq("_blank")
  end

  scenario "users can view a resource" do
    user = feature_login
    resource = create(:resource, resource_type: :url, url: "http://example.com", user: user)

    click_link "My Resources"
    click_link resource.title

    expect(page).to have_text("URL")
    expect(page).to have_text("http://example.com")
  end

  scenario "users can create a resource" do
    user = feature_login
    resource = build(:resource, resource_type: :url, url: "http://example.com", user: user)

    click_link "Add Resource"

    within("#new_resource") do
      fill_in "resource[title]", with: resource.title
      fill_in "resource[url]", with: resource.url
      click_on "CREATE"
    end

    expect(find("h1")).to have_content(resource.title)
    expect(Resource.count).to eq 1
  end

  scenario "users can update a resource" do
    user = feature_login
    resource = create(:resource, resource_type: :url, url: "http://example.com", user: user)

    visit edit_resource_path(resource)
    within("#edit_resource_#{resource.id}") do
      fill_in "resource[title]", with: "Water Experiments"
      click_on "UPDATE"
    end

    expect(find("h1")).to have_content("Water Experiments")
    expect(Resource.last.title).to eq "Water Experiments"
  end

  scenario "users can destroy a resource" do
    user = feature_login
    resource = create(:resource, resource_type: :url, url: "http://example.com", user: user)

    visit resource_path(resource)
    click_link "DELETE"

    expect(Resource.count).to eq 0
  end
end
