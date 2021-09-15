$(document).ready(function(){

  addDataShowsForPermission();

  $('#content').on('change', 'input[data-disables], input[data-enables], input[data-shows]', toggleVisibilityOnChange);
  toggleVisibilityInit();

  function toggleVisibilityOnChange() {
    var checked = $(this).is(':checked');
    if(!checked) {
      $($(this).data('shows')).css('visibility', 'hidden');
    }
    else {
      $($(this).data('shows')).css('visibility', 'visible');
    }

  }

  function addDataShowsForPermission() {
    $('[class^="role-"]').each(function(){
      //get roleId after delete role-
      roleid = $(this).attr('class').substring(5);
      st = "." + $(this).attr('value') + "-" + roleid + "_shown";
      $(this).attr('data-shows', st);
    });
  }

  function toggleVisibilityInit() {
    $('input[data-disables], input[data-enables], input[data-shows]').each(toggleVisibilityOnChange);
  }
});

function setSelect2ForElement(element, url) {
  element.select2({
    containerCss: {width: '268px', minwidth: '268px'},
    width: 'style',
    tags: false,
    multiple: true,
    language: {
        noResults: function () {
          return "Aucun résultat trouvé..";
        },
        searching: function() {
            return "Recherche...";
        }
    },
    ajax: { url: url,
      dataType: 'json',
        delay: 250,
        method: 'GET',
        data: function (params) {
          return {
              term: params.term,
              page_limit: 20,
              page: params.page || 0
          };
        },
        processResults: function (data, params) {
          params.page = params.page || 0;
          maxPage = Math.ceil(data.total / 20);
          return {
              results: data.results,
               pagination: {
                  more: ((params.page * 20) < data.total) && (data.results.length < data.total) && (maxPage > params.page + 1)
              }
          };
        },
        cache: true
      },
    minimumInputLenght: 20,

  });
}