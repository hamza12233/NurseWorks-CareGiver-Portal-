module ApplicationHelper

  def user_global_search_helper(q)
    ["first_name LIKE ? OR  last_name LIKE ? OR email LIKE ? OR phone like ? OR id = ?", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", q]
  end

  def sr_global_search_helper(q)
    ["support_requests.id = ? OR req_type LIKE ? OR user_id = ?", q, "%#{q}%", q]
  end

  def sr_global_search_helper(q)
    ["support_requests.id = ? OR req_type LIKE ? OR user_id = ?", q, "%#{q}%", q]
  end

  def user_docs_global_search_helper(q)
    ["users.first_name LIKE ? OR users.last_name LIKE ? OR users.email LIKE ? OR user_id = ?", "%#{q}%", "%#{q}%", "%#{q}%", q]
  end
end
