json.meta do
  json.labels @conversation.cached_label_list_array
  json.additional_attributes @conversation.additional_attributes
  if Current.account_user.administrator?
    json.contact @conversation.contact.push_event_data
  else
    json.contact @conversation.contact.push_event_data.merge(email: nil, phone_number: nil, additional_attributes: {})
  end
  json.assignee @conversation.assignee.push_event_data if @conversation.assignee.present?
  json.agent_last_seen_at @conversation.agent_last_seen_at
  json.assignee_last_seen_at @conversation.assignee_last_seen_at
end

json.payload do
  json.array! @messages do |message|
    json.partial! 'api/v1/models/message', message: message
  end
end
