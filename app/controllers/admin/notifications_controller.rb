class Admin::NotificationsController < AdminController
  respond_to :html, :json, :js

  def index
    @search_params = params.slice(*allowed_search_params)
    @notifiers = current_user.notifiers.reorder(:name)
    @notifications = search(Notification.where(:notifier_id => @notifiers), @search_params)
    @notifications_count = @notifications.count
    @notifications = @notifications.order('delivery_start DESC').page(params[:page])

    respond_with @notifications
  end

  def show
    @notifiers = current_user.notifiers
    @notification = Notification.where(:notifier_id => @notifiers).find(params[:id])
    @notifier_id = @notification.notifier.id
    @notifier_name = @notification.notifier.name
    @attempts = @notification.delivery_attempts
    @message = @notification.message
    respond_with @notification
  end

  def new
    @notification = Notification.new
    @notification[:message_id] = params[:message_id]
    @notification[:delivery_method] = params[:delivery_method]

    respond_with :admin, @notification
  end

  def create
    @notification = Notification.new
    @notification.attributes = params[:notification]
    @notification.notifier = Notifier.find_by_username('internal')
    @notification.uuid ||= SecureRandom.uuid
    @notification.delivery_start ||= Time.zone.now

    if @message = @notification.message
      @notification.delivery_method = @message.delivery_method
    end

    @notification.save
    respond_with :admin, @notification
  end


  private

  def allowed_search_params
    %w(
      delivery_method_eq delivery_start_gteq delivery_start_lteq
      delivered_at_gteq delivered_at_lteq delivered_at_null
      first_name_cont last_error_type_eq notifier_id_eq
      phone_number_cont phone_number_eq status_eq
    )
  end

end
