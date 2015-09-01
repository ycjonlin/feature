/*eslint "no-var":0 */
'use strict';

var bootstrap = require('bootstrap-styl');
var browserify = require('browserify');
var browserSync = require('browser-sync');
var docco = require('gulp-docco');
var duration = require('gulp-duration');
var gulp = require('gulp');
var gutil = require('gulp-util');
var jade = require('gulp-jade');
var notifier = require('node-notifier');
var path = require('path');
var prefix = require('gulp-autoprefixer');
var replace = require('gulp-replace');
var rev = require('gulp-rev');
var rimraf = require('rimraf');
var shell = require('gulp-shell');
var source = require('vinyl-source-stream');
var sourcemaps = require('gulp-sourcemaps');
var streamify = require('gulp-streamify');
var stylus = require('gulp-stylus');
var uglify = require('gulp-uglify');
var watchify = require('watchify');

/*eslint "no-process-env":0 */
var production = process.env.NODE_ENV === 'production';

var config = {
  destination: './public',
  documents: {
    source: './src/coffee/*.coffee',
    watch: './src/coffee/*.coffee',
    destination: './doc/'
  },
  scripts: {
    source: './src/coffee/main.coffee',
    extensions: ['.coffee'],
    destination: './public/js/',
    filename: 'bundle.js'
  },
  templates: {
    source: './src/jade/*.jade',
    watch: './src/jade/*.jade',
    destination: './public/',
    revision: './public/**/*.html'
  },
  styles: {
    source: './src/stylus/style.styl',
    watch: './src/stylus/*.styl',
    destination: './public/css/'
  },
  assets: {
    source: './src/assets/**/*.*',
    watch: './src/assets/**/*.*',
    destination: './public/'
  },
  revision: {
    source: ['./public/**/*.css', './public/**/*.js'],
    base: path.join(__dirname, 'public'),
    destination: './public/'
  }
};

var browserifyConfig = {
  entries: [config.scripts.source],
  extensions: config.scripts.extensions,
  debug: !production,
  cache: {},
  packageCache: {}
};

function handleError(err) {
  gutil.log(err);
  gutil.beep();

  notifier.notify({
    title: 'Compile Error',
    message: err.message
  });

  return this.emit('end');
}

gulp.task('scripts', function() {
  var pipeline = browserify(browserifyConfig)
    .bundle()
    .on('error', handleError)
    .pipe(source(config.scripts.filename));

  if(production) {
    pipeline = pipeline.pipe(streamify(uglify()));
  }

  return pipeline.pipe(gulp.dest(config.scripts.destination));
});

gulp.task('documents', function() {
  return gulp.src(config.documents.source)
    .pipe(docco())
    .pipe(gulp.dest(config.documents.destination));
});

gulp.task('templates', function() {
  var pipeline = gulp.src(config.templates.source)
  .pipe(jade({
    pretty: !production
  }))
  .on('error', handleError)
  .pipe(gulp.dest(config.templates.destination));

  if(production) {
    return pipeline;
  }

  return pipeline.pipe(browserSync.reload({
    stream: true
  }));
});

gulp.task('styles', function() {
  var pipeline = gulp.src(config.styles.source);

  if(!production) {
    pipeline = pipeline.pipe(sourcemaps.init());
  }

  pipeline = pipeline.pipe(stylus({
    'include css': true,
    compress: production,
    use: bootstrap()
  }))
  .on('error', handleError)
  .pipe(prefix('last 2 versions', 'Chrome 34', 'Firefox 28', 'iOS 7'));

  if(!production) {
    pipeline = pipeline.pipe(sourcemaps.write('.'));
  }

  pipeline = pipeline.pipe(gulp.dest(config.styles.destination));

  if(production) {
    return pipeline;
  }

  return pipeline.pipe(browserSync.stream({
    match: '**/*.css'
  }));
});

gulp.task('assets', function() {
  return gulp.src(config.assets.source)
    .pipe(gulp.dest(config.assets.destination));
});

gulp.task('server', function() {
  return browserSync({
    open: false,
    port: 9001,
    server: {
      baseDir: config.destination
    }
  });
});

gulp.task('watch', function() {
  gulp.watch(config.documents.watch, ['documents']);
  gulp.watch(config.templates.watch, ['templates']);
  gulp.watch(config.styles.watch, ['styles']);
  gulp.watch(config.assets.watch, ['assets']);

  var bundle = watchify(browserify(browserifyConfig));

  bundle.on('update', function() {
    var build = bundle.bundle()
      .on('error', handleError)
      .pipe(source(config.scripts.filename));

    build.pipe(gulp.dest(config.scripts.destination))
    .pipe(duration('Rebundling browserify bundle'))
    .pipe(browserSync.reload({stream: true}));
  }).emit('update');
});

var buildTasks = ['documents', 'templates', 'styles', 'assets'];

gulp.task('revision', buildTasks.concat(['scripts']), function() {
  return gulp.src(config.revision.source, {base: config.revision.base})
    .pipe(rev())
    .pipe(gulp.dest(config.revision.destination))
    .pipe(rev.manifest())
    .pipe(gulp.dest('./'));
});

gulp.task('replace-revision-references', ['revision', 'templates'], function() {
  var revisions = require('./rev-manifest.json');

  var pipeline = gulp.src(config.templates.revision);

  pipeline = Object.keys(revisions).reduce(function(stream, key) {
    return stream.pipe(replace(key, revisions[key]));
  }, pipeline);

  return pipeline.pipe(gulp.dest(config.templates.destination));
});

gulp.task('build', function() {
  rimraf.sync(config.destination);
  gulp.start(buildTasks.concat(['scripts', 'revision', 'replace-revision-references']));
});

gulp.task('default', buildTasks.concat(['watch', 'server']));
