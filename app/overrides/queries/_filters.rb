Deface::Override.new :virtual_path  => "queries/_filters",
                     :name          => "add-select2-to-elements-that-use-the-users-list ",
                     :insert_after => "div.add-filter",
                     :text       => <<SELECT2
<script>

  // declare the function here, in order to generate the path by rails
  function prepareTheElementsForSelect2() {
    // check if values_author_id_1 defined
    if ($('#values_author_id_1').length > 0) {
      setSelect2ForElement($('#values_author_id_1'), '<%= author_values_pagination_path %>');
    }
    if ($('#values_last_updated_by_1').length > 0) {
      setSelect2ForElement($('#values_last_updated_by_1'), '<%= author_values_pagination_path %>');
    }
    if ($('#values_updated_by_1').length > 0) {
      setSelect2ForElement($('#values_updated_by_1'), '<%= author_values_pagination_path %>');
    }
    if ($('#values_user_id_1').length > 0) {
      setSelect2ForElement($('#values_user_id_1'), '<%= author_values_pagination_path %>');
    }

    if ($('#values_assigned_to_id_1').length > 0) {
      setSelect2ForElement($('#values_assigned_to_id_1'), '<%= assigned_to_values_pagination_path %>');
    }
  }

  $(document).ready(function(){

    // case of refresh or submit
    prepareTheElementsForSelect2();

    // because of the elements are created by event onChange
    $('#add_filter_select').change(function(e) {
      prepareTheElementsForSelect2();
    });

  });
</script>
SELECT2