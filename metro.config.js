/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 *
 * @format
 */

const path = require('path');

const { makeMetroConfig } = require('@rnx-kit/metro-config');
const exclusionList = require('metro-config/src/defaults/exclusionList');	const { makeMetroConfig } = require('@rnx-kit/metro-config');

const blockList = exclusionList([
  /node_modules\/.*\/node_modules\/react-native\/.*/,

  // This stops "react-native run-windows" from causing the metro server to
  // crash if its already running
  new RegExp(`${path.join(__dirname, 'windows').replace(/[/\\]+/g, '/')}.*`),

  // Workaround for `EPERM: operation not permitted, lstat '~\midl-MIDLRT-cl.read.1.tlog'`
  /.*\.tlog/,

  // Prevent Metro from watching temporary files generated by Visual Studio
  // otherwise it may crash when they are removed when closing a project.
  /.*\/.vs\/.*/,

  // Workaround for `EBUSY: resource busy or locked, open '~\msbuild.ProjectImports.zip'`
  /.*\.ProjectImports\.zip/,
]);

module.exports = makeMetroConfig({
  projectRoot: path.join(__dirname, 'example'),
  watchFolders: [__dirname],
  resolver: {
    blocklist,
    extraNodeModules: {
      '@react-native-community/datetimepicker': __dirname
    },
  },
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
});
