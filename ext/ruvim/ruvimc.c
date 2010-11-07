/**
 *  Ruvim C Extension
 *
 */

#include <ruby/ruby.h>
#include <curses.h>

#if defined(HAVE_USE_DEFAULT_COLORS)
static VALUE
ruvim_curses_use_default_colors(VALUE obj)
{
    use_default_colors();
    return Qnil;
}
#else
#define ruvim_curses_use_default_colors rb_f_notimplement
#endif

void Init_ruvimc()
{
	VALUE mCurses = rb_define_module("Curses");

	if (!rb_respond_to(mCurses, rb_intern("use_default_colors")))
		rb_define_module_function(mCurses, "use_default_colors", ruvim_curses_use_default_colors, 0);


}
