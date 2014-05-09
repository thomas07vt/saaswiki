
// function populateWikiBody() {
//   //Get text from editor to store.
//   //There are nexted iframes here, so we have to do some work to get the actual body text.
//   var editorDiv = document.getElementById('epiceditor');
//   var oIframe = editorDiv.childNodes[0];
//   var oInnerDoc = oIframe.contentDocument || oIframe.contentWindow.document;
//   var iIframe = oInnerDoc.getElementById('epiceditor-editor-frame');
//   var iInnerDoc = iIframe.contentDocument || iIframe.contentWindow.document;
//   var wikibody = iInnerDoc.getElementsByTagName('body')[0].innerHTML;
//   var formBody = document.getElementById('wiki_body');

//   //Set the form body text to what is in the iframe body
//   formBody.value = wikibody;

//   //Submit the for with the Wiki name and Wiki body.
//   document.getElementById("new_wiki").submit();
// }

// function saveWiki() {
//   populateWikiBody();
// }

// function onPageLoad() {
//   var editor = new EpicEditor({ container: 'epiceditor', basePath: '', theme: { base: '/EpicEditor-v0.2.2/themes/base/epiceditor.css', preview: '/EpicEditor-v0.2.2/themes/preview/github.css', editor: '/EpicEditor-v0.2.2/themes/editor/epic-light.css' } });
//   editor.load();
// }