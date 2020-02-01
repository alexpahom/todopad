require './todo_model'

[
    ['Выбросить мусор', 'ты сам все понял', :progress, 1],
    ['Почитать инженерную графику', 'курсовая - нейронная сеть, ищи статьи', :open, 1],
    ['Зашить носки', 'Нашел 5 дырок в новых носках', :close, 1],
    ['Магаз', 'Сметана, хлеб, бананы', :open, 2]
].each do |title, description, status, rank|
  Task.create(
      title: title,
      description: description,
      status: status,
      rank: rank
  )
end
