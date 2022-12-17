if Rails.env === 'production'
  Rails.application.config.session_store :cookie_store, key: '_lightnotes', same_site: :none, secure: true, domain: :all
else
  Rails.application.config.session_store :cookie_store, key: '_journeys', same_site: :none
end
