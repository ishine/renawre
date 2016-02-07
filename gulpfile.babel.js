'use strict';

import Promise from 'bluebird';
import gulp from 'gulp';

import Ewpss from 'ewpss';
import * as ewpss from 'ewpss';

let objEwpss;

function registerTasks() {
  gulp.task('initialize', taskInitialize);
  gulp.task('steps', ['initialize'], makeScriptFunc('srcsteps/**/*.sh', 'renawre'));
  gulp.task('default', ['steps']);
}

function makeScriptFunc(src, dest) {
  return () => {
    return gulp.src(src)
      .pipe(objEwpss.getVinylTransform())
      .pipe(gulp.dest(dest));
  };
}

function taskInitialize() {
  return Promise.props({
    '$': ewpss.loadBuiltinsTuple()
  }).then((objs) => {
    objEwpss = new Ewpss(objs);
  })
}

registerTasks();
