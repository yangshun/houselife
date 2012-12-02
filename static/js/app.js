$(function () {

    user = {
        id: 123
    };
    var App = Backbone.Router.extend({
        initialize: function () {
            var tasks = new TaskCollection();
            tasks.fetch();


            var views = this.views = {
                'todo': new TodoView(),
                'profile': new ProfileView(),
                'feed': new FeedView(),
                'analytics': new AnalyticsView(),
                'expenses': new ExpensesView()
            };

            var hideViews = this.hideViews = function () {
                for (var i in views) {
                    views[i].hide();
                }
            };

            var thisApp = this;

            $('#nav-todo').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/todo', {trigger:true});
            });

            $('#nav-profile').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/profile', {trigger:true});
            });

            $('#nav-feed').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/feed', {trigger:true});
            });

            $('#nav-analytics').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/profile', {trigger:true});
            });

            $('#nav-expenses').click(function(e) {
                e.preventDefault();
                thisApp.navigate('dashboard/expenses', {trigger:true});
            });

            this.route(/^dashboard\/(.*)/, "view", this.showView);
        },
        showView: function(view) {
            this.hideViews();
            this.views[view].show();
        }
    });

    var NavigationView = Backbone.View.extend({
        hide: function () {
            this.$el.hide();
        },
        show: function () {
            this.$el.show();
        }
    });


    var TodoView = NavigationView.extend({
        el: $('#todo-container')

    });

    var ProfileView = NavigationView.extend({
        el: $('#profile-container')
    });

    var FeedView = NavigationView.extend({
        el: $('#feed-container')
    });

    var AnalyticsView = NavigationView.extend({
        el: $('#analytics-container')
    });

    var ExpensesView = NavigationView.extend({
        el: $('#expenses-container')
    });


    app = new App({});

    Backbone.history.start({pushState:true});



});