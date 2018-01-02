// See http://brunch.io for documentation.
exports.files = {
  //javascripts: { joinTo: 'lib.js' },
  stylesheets: { joinTo: 'app.css' }
  //<templates: { joinTo: "lib.js" }
};

exports.plugins = {
  elmBrunch: {
    mainModules: ["app/App.elm"],
    outputFolder: "public/",
    makeParameters: []
  }
};