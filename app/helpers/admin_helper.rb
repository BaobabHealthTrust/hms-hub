module AdminHelper
  def primary_nav(selected=:dashboard)
    nav = [
      { :name => :dashboard,     :path => admin_path                   },
      { :name => :messages,      :path => admin_message_streams_path   },
      { :name => :notifiers,     :path => admin_notifiers_path         },
      { :name => :notifications, :path => admin_notifications_path     },
      { :name => :attempts,      :path => admin_delivery_attempts_path },
      { :name => :jobs,          :path => admin_jobs_path              },
      { :name => :users,         :path => admin_users_path             },
      { :name => :reports,       :path => admin_reports_path           },
    ]

    nav.each { |i| i[:title] ||= t("admin.primary_nav.#{i[:name]}") }
    nav.select { |i| i[:name] == selected }[0][:selected] = true
    nav
  end

  def nav_hierarchy(hierarchy)
    paths = Hash[primary_nav.map { |n| [n[:name], n[:path]] }]
    hierarchy.map do |node|
      case node
      when Symbol # toplevel nav/collection or action
        title = t("admin.primary_nav.#{node}", :default => [:"admin.common.actions.#{node}"])
        paths[node] ? link_to(title, paths[node]) : title
      when MessageStream
        link_to("#{node.class.model_name.human}: #{node.title}", [:admin, node])
      when Message
        link_to("#{node.class.model_name.human}: #{node.title}", [:admin, node.message_stream, node])
      when Notifier
        link_to("#{node.class.model_name.human}: #{node.username}", [:admin, node])
      when Notification
        link_to("#{node.class.model_name.human}: #{node.id}", [:admin, node])
      when Delayed::Job
        link_to("#{node.class.model_name.human}: #{node.id}", admin_job_path(node))
      when DeliveryAttempt
        link_to("#{node.class.model_name.human}: #{node.id}", [:admin, node])
      when User
        link_to("#{node.class.model_name.human}: #{node.username}", [:admin, node])
      else
        node
      end
    end
  end

end
