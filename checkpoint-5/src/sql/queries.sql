select will_the_real_allegation_id_please_stand_up as allegation_id, section_name, column_name, text_content, name, median_income, gender as complainant_gender, race as complainant_race, birth_year as complainant_birth_year from
(select * from
((select allegation_id as will_the_real_allegation_id_please_stand_up, section_name, column_name, text_content from
(select allegation_id, data_attachmentfile.id as attachment_id
from data_attachmentfile inner join data_allegation
on data_attachmentfile.allegation_id = data_allegation.crid) as af
inner join data_attachmentnarrative
on data_attachmentnarrative.attachment_id=af.attachment_id) as an
inner join data_allegation_areas on an.will_the_real_allegation_id_please_stand_up=data_allegation_areas.allegation_id) as an_area
inner join data_area on an_area.area_id=data_area.id where area_type='community') as aa
join data_complainant on data_complainant.allegation_id=will_the_real_allegation_id_please_stand_up;
