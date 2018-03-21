class Setting < ApplicationRecord

  ## ASSOCIATIONS
  belongs_to :shop
  has_many :emails, dependent: :destroy, before_add: :ensure_email_can_be_associated
  accepts_nested_attributes_for :emails, allow_destroy: true, reject_if: proc { |attributes| attributes[:address].blank? }

  ## VALIDATIONS
  validates :name, :webhook_topic, :webhook_action_name, presence: true
  validates :need_emails, :value, inclusion: { in: [true, false] }

  ## CALLBACKS
  after_update :ensure_emails_count_valid, if: [:need_emails, :value]
  after_update :register_webhook, if: [:value_changed?, :value]
  before_save :destory_dependent_emails, on: :update, if: [:value_changed?, :value_was, :need_emails]
  before_save :destory_webhook, on: :update, if: [:value_changed?, :value_was]


  def pretty_errors
    errors.full_messages.join(" and ")
  end

  private

  def ensure_emails_count_valid
    if has_invalid_emails_count
      errors[:emails] << I18n.t(:invalid_email_count, scope: [:setting, :errors], email_count: ENV['minimum_email_count'].to_i )
      raise ActiveRecord::Rollback
    end
  end

  def has_invalid_emails_count
    emails.count < ENV['minimum_email_count'].to_i
  end

  def register_webhook
    webhook = ShopifyAPI::Webhook.create(topic: webhook_topic, format: 'json', address: ENV['hostname'] + '/webhooks/' + webhook_action_name)
    if webhook.errors.any?
      webhook.errors.full_messages.each do |webhook_error_full_message|
        errors[:base] << webhook_error_full_message
      end
      throw :abort
    else
      update_columns(webhook_id: webhook.id)
    end
  end

  def destory_webhook
    begin
      ShopifyAPI::Webhook.delete webhook_id
      webhook_id = nil
    rescue ActiveResource::ResourceNotFound => exception
      errors[:base] << exception.message
      throw :abort
    rescue Exception => exception
      errors[:base] << exception.message
      throw :abort
    end
  end

  def ensure_email_can_be_associated(setting)
    if need_emails == false || value == false
      errors[:base] << I18n.t(:email_cannot_be_added, scope: [:setting, :error])
      raise ActiveRecord::Rollback
    end
  end

  def destory_dependent_emails
    emails.destroy_all
  end

end
