
$(function () {
    TaskView = Backbone.View.extend({
        model: Task,
        initialize: function () {
            if (this.model instanceof Task) {
                this.renderNormalView();
            }
        },
        renderNormalView: function () {

            var thisView = this;
            var $tableRow = $('<tr>');


            var $descriptionEntry = $('<td>');
            $descriptionEntry.html(this.model.get('description'));
            var $titleEntry = $('<td>');
            $titleEntry.html(this.model.get('title'));
            var $assigneeEntry = $('<td>');
            $assigneeEntry.html(appVars.household.get(this.model.get('assignee_id')));
            var $statusEntry = $('<td>');
            $statusEntry.html(this.model.get('status'));

            var $editEntry = $('<td>');
            var $editButton = $('<button class="btn">Edit</button>');
            $editButton.click(function () {
                thisView.renderEditView();
            });
            $editEntry.append($editButton);

            var $deleteEntry = $('<td>');
            var $deleteButton = $('<button class="btn">Delete</button>');
            $deleteButton.click(function () {
                thisView.model.destroy({
                    wait:true
                });
            });
            $deleteEntry.append($deleteButton);

            $tableRow
                .append($descriptionEntry)
                .append($titleEntry)
                .append($assigneeEntry)
                .append($statusEntry)
                .append($editEntry)
                .append($deleteEntry);

            this.$el.replaceWith($tableRow);
            this.setElement($tableRow);
            return $tableRow;
        },

        renderEditView: function () {
            var thisView = this;

            var $tableRow = $('<tr>');


            var $descriptionEntry = $('<td>');
            var $descriptionInput = $('<input>');
            $descriptionInput
                .val(this.model.get('description'))
                .on('change', function () {
                    thisView.model.set('description', $(this).val());
                })
                .appendTo($descriptionEntry);
            var $titleEntry = $('<td>');
            var $titleInput = $('<input>');
            $titleInput
                .val(this.model.get('title'))
                .on('change', function () {
                    thisView.model.set('title', $(this).val());
                })
                .appendTo($titleEntry);
            var $assigneeEntry = $('<td>');

            var user = appVars.household.find(
                function (user) {
                    return user.get('objectId') == thisView.model.get('assignee_id');
                }
            );

            $assigneeEntry.html();
            var $statusEntry = $('<td>');
            var $statusInput = $('<select><option value="0">Open</option><option value="1">Completed</option>');
            $statusInput
                .val(this.model.get('status'))
                .on('change', function () {
                    thisView.model.set('status', $(this).val());
                })
                .appendTo($statusEntry);

            var $saveEntry = $('<td>');
            var $saveButton = $('<button class="btn">Save</button>');
            $saveButton.click(function () {
                thisView.renderNormalView();
                thisView.model.save({
                    success: function () {
                        alert("save success!");
                    }
                });
            });
            $saveEntry.append($saveButton);

            var $deleteEntry = $('<td>');
            var $deleteButton = $('<button class="btn">Delete</button>');
            $deleteEntry.append($deleteButton);

            $tableRow
                .append($descriptionEntry)
                .append($titleEntry)
                .append($assigneeEntry)
                .append($statusEntry)
                .append($saveEntry)
                .append($deleteEntry);

            this.$el.replaceWith($tableRow);
            this.setElement($tableRow);
            return $tableRow;
        }

    });

    TaskCollectionView = Backbone.View.extend({
        collection: TaskCollection,
        initialize: function () {
            var taskViews = this.taskViews = {};

            var thisCollectionView = this;

            var addView = function (model) {
                newTaskView = new TaskView({
                    'model': model
                });

                taskViews[model.cid] = newTaskView;

                thisCollectionView.$el.append(newTaskView.$el);
            };

            this.collection.on('add', addView);

            this.collection.on('remove', function (model) {
                taskViews[model.cid].remove();
            });

            this.collection.on('reset', function (collection) {
                for (var i in taskViews) {
                    taskViews[i].remove();
                }

                for (var j = 0; j < collection.models.length; j++) {
                    var collectionModel = collection.models[j];
                    addView(collectionModel);
                }
            });

            // Initialize this DOM element

            var $table = $('<table>');
            var $tableRow = $('<tr>');
            $table.append($tableRow);

            var headers = ["Description", "Title", "Assignee", "Status", "Options"];

            for (var i = 0; i < headers.length; i++) {
                $tableRow.append($('<th>'+headers[i]+'</th>'));
            }

            this.setElement($table);
        }
    });
});

