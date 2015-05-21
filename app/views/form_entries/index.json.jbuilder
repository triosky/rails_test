json.tasks(@entries) do |task|
  json.extract! task, :id, :user_id, :approver_id, :status, :answers, :created_at, :updated_at
  json.url company_task_url(task, format: :json)
  if !task.user.nil?
    json.user do
      json.name task.user.name
      json.id task.user.id
    end
  end
  json.approver do
    json.name task.approver.present? ? task.approver.name : ''
    json.id task.approver.present? ? task.approver.id : ''
  end
  json.form do
    json.name task.form.name
    json.id task.form.id
  end
end
