$(function () {

    appVars = {};

    user = {
        id: 123
    };
    var App = Backbone.Router.extend({
        initialize: function () {

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

            $('#nav-logout').click(function (e) {
                e.preventDefault();
                window.location.href = '/logout';
            });

            this.route(/^dashboard\/(.*)/, "default", function () {
                this.showView('todo');
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
        el: $('#todo-container'),
        initialize: function () {
            taskCollection = new TaskCollection();
            taskCollectionView = new TaskCollectionView({
                collection: taskCollection
            });

            taskCollection.grab(function () {
                    $('#add-task-btn').click(function () {
                    var newTask = new Task();
                    taskCollection.add(newTask);
                    taskCollectionView.taskViews[newTask.cid].renderEditView();
                });
            }, true);

            $('#tasks-container').append(taskCollectionView.$el);


        }

    });

    var ProfileView = NavigationView.extend({
        el: $('#profile-container'),
        initialize: function () {

        }
    });

    var FeedView = NavigationView.extend({
        el: $('#feed-container'),
        initialize: function() {

        }
    });

    var AnalyticsView = NavigationView.extend({
        el: $('#analytics-container'),
        initialize: function () {

        }
    });

    var ExpensesView = NavigationView.extend({
        el: $('#expenses-container'),
        initialize: function () {

        }
    });

    appVars.household = new Household();
    appVars.household.grab(function () {
        app = new App({});
        Backbone.history.start({pushState:true});

    }, true);

    appVars.user = new User();
    appVars.user.set(user);

    



});