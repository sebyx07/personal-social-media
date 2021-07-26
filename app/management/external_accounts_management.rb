# frozen_string_literal: true

ActiveAdmin.register ExternalAccount, namespace: :management do
  searchable_select_options(scope: ->(params) do
    scoped_collection.where(usage: params[:usage])
  end,
  text_attribute: :name)

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    div(class: "flex flex-wrap") do
      div(class: "w-3/5") do
        div(class: "w-full flex") do
          div(class: "w-1/2") do
            f.input :name, label: "Account name or information", required: true
          end

          div(class: "w-1/2") do
            f.input :service, as: :select, collection: formatted_services, include_blank: false
          end
        end

        div(class: "w-full flex") do
          div(class: "w-1/2") do
            f.input :email, as: :email
          end

          div(class: "w-1/2") do
            f.input :password, input_html: { type: :text }
          end
        end

        div(class: "w-full flex") do
          div(class: "w-1/2") do
            f.input :secret
          end
        end

        div(class: "w-full flex") do
          div(class: "w-1/2") do
            f.input :public_key
          end

          div(class: "w-1/2") do
            f.input :secret_key
          end
        end
      end
      div do
        render partial: "management/external_accounts/affiliate_links"
      end
    end

    f.actions
  end

  controller do
    def formatted_services
      @formatted_services ||= ExternalAccount.services.map do |service|
        [I18n.t("external_accounts.services.#{service}.name"), service]
      end
    end

    helper_method :formatted_services
  end
end
