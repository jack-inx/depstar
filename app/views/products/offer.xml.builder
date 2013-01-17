xml.instruct!
xml.response do
  xml.offer @question_response.quote unless @question_response.nil?
end