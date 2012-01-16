xml.instruct!
xml.response do
  # xml.total @categories.count
  # xml.returned @categories.count
  xml.questions do
    if @product.question_1_is_enabled
      xml.question do
        xml.text @product.question_1_name
        xml.required 'true'
        xml.id 'question_1'
        xml.answers do
          xml.answer do
            xml.text 'Yes'
            xml.id 'answer_1'
          end
          xml.answer do
            xml.text 'No'
            xml.id 'answer_2'
          end
        end
      end
    end
    
    if @product.question_2_is_enabled
      xml.question do
        xml.text @product.question_2_name
        xml.required 'true'
        xml.id 'question_2'
        xml.answers do
          xml.answer do
            xml.text 'Yes'
            xml.id 'answer_3'
          end
          xml.answer do
            xml.text 'No'
            xml.id 'answer_4'
          end
        end
      end
    end
    
    if @product.question_3_is_enabled
      xml.question do
        xml.text @product.question_3_name
        xml.required 'true'
        xml.id 'question_3'
        xml.answers do
          xml.answer do
            xml.text 'Poor'
            xml.id 'answer_5'
          end
          xml.answer do
            xml.text 'Average'
            xml.id 'answer_6'
          end
          xml.answer do
            xml.text 'Good'
            xml.id 'answer_7'
          end
          xml.answer do
            xml.text 'Excellent'
            xml.id 'answer_8'
          end
        end
      end
    end

    if @product.question_4_is_enabled
      @product.question_options.each do |question_option|
        xml.question do
          xml.text question_option.name
          xml.required 'false'
          xml.id 'option_' + question_option.id.to_s
          xml.answers do
            xml.answer do
              xml.text 'Yes'
              xml.id 'option_answer_' + question_option.id.to_s + '_1'
            end
            xml.answer do
              xml.text 'No'
              xml.id 'option_answer_' + question_option.id.to_s + '_2'
            end
          end
        end
      end
    end
    
    # if @product.question_4_is_enabled
    #       xml.question do
    #         xml.text @product.question_4_name
    #         xml.required 'false'
    #         xml.id 'question_4'
    #         xml.answers do
    #           @product.question_options.each do |question_option|
    #             xml.answer do
    #               xml.text question_option.name
    #               xml.id 'option_' + question_option.id.to_s
    #             end
    #           end
    #         end
    #       end
    #     end


  end
end