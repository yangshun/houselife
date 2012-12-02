$(function () {

    appVars = {};

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


            $('#nav-analytics').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/analytics', {trigger:true});
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
                    $( "#dialog-modal" ).dialog({
                        height: 440,
                        width: 850,
                        modal: true
                    });
                    /*
                    var newTask = new Task({
                        "household_id": appVars.user.get('household_id')
                    });
                    taskCollection.add(newTask);
                    taskCollectionView.taskViews[newTask.cid].renderEditView(true);
                    */
                });
            }, false);
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
            var thisView = this;

            if (google.visualization) {
                drawChart();
            } else {
                google.setOnLoadCallback(drawChart);
            }
            function drawChart() {
                var dataArray = [];
                dataArray.push(['User', 'Tasks Completed']);
                for (var i = 0; i < taskCollection.length; i++) {
                    
                }

                var data = google.visualization.arrayToDataTable([
                  ['Task', 'Hours per Day'],
                  ['Work',     11],
                  ['Eat',      2],
                  ['Commute',  2],
                  ['Watch TV', 2],
                  ['Sleep',    7]
                ]);

                var options = {
                  title: 'My Daily Activities'
                };
                var chart = new google.visualization.PieChart(thisView.el);
                chart.draw(data, options);
            }
        }
    });

    var ExpensesView = NavigationView.extend({
        el: $('#expenses-container'),
        initialize: function () {

        }
    });

    appVars.user = new User(user);
    appVars.household = new Household(appVars.user.get('household_id'));
    appVars.household.grab(function () {
        app = new App({});
        Backbone.history.start({pushState:true});

        new ModalEditView();

    }, false);

    appVars.user = new User();
    appVars.user.set(user);

    



});