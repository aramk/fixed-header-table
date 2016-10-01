Package.describe({
  name: 'aramk:fixed-header-table',
  summary: 'jQuery plugin to fix table header during scroll.',
  git: 'https://github.com/aramk/fixed-header-table.git',
  version: '0.1.0'
});

Package.on_use(function(api) {
  api.versionsFrom('METEOR@1.2.0.1');
  api.use([
    'coffeescript',
    'jquery',
    'less'
  ], 'client');
  api.addFiles([
    'src/fixedHeaderTable.coffee',
    'src/fixedHeaderTable.less'
  ], 'client');
});
