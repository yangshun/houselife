
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
                .appendTo($descriptionEntry);
            var $titleEntry = $('<td>');
            var $titleInput = $('<input>');
            $titleInput
                .val(this.model.get('title'))
                .appendTo($titleEntry);
            var $assigneeEntry = $('<td>');
            $assigneeEntry.html(appVars.household.get(this.model.get('assignee_id')));
            var $statusEntry = $('<td>');
            var $statusInput = $('<input>');
            $statusInput
                .val(this.model.get('status'))
                .appendTo($statusEntry);

            var $saveEntry = $('<td>');
            var $saveButton = $('<button class="btn">Save</button>');
            $saveButton.click(function () {
                // TODO: Implement save
                thisView.renderNormalView();
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

            this.collection.on('reset', function (model, collection) {
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

