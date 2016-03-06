'use strict';

import Promise from 'bluebird';
import gulp from 'gulp';

import Ewpss from 'ewpss';
import * as ewpss from 'ewpss';

let objEwpss;

function registerTasks() {
  gulp.task('default', ['steps']);
  gulp.task('steps', ['initialize', 'stepsMacro'],
    makeEwpssFunc('tmp/steps/**/*.sh', 'renawre', 'getVinylTemplater'));
  gulp.task('stepsMacro', ['initialize'],
    makeEwpssFunc('srcsteps/**/*.sh', 'tmp/steps', 'getVinylMacroer'));
  gulp.task('initialize', taskInitialize);
}

function makeEwpssFunc(src, dest, getterName) {
  return () => {
    return gulp.src(src)
      .pipe(objEwpss[getterName]())
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
