# Super Scaffold

A scaffold with superpowers! Pin the Drawer on the left of screen. Pin the AppBar on the top of screen. Show confirmation dialog and loading screen easily.

## Pin the Drawer on the left of screens

If you want to make your application responsive to another orientation (like landscape), but you're using the default Flutter Scaffold, then you'll see that behaviour:

![Flutter Scaffold Landscape](https://raw.githubusercontent.com/lucaslannes/super_scaffold/main/assets/README/flutter_scaffold_landscape.png)

How we can solve this problem? Just replace your Scaffold widget with the SuperScaffold widget.

```dart
@override
Widget build(BuildContext context) {
    return SuperScaffold(
        drawer: Drawer(),
    );
}
```

![Super Scaffold Landscape](https://raw.githubusercontent.com/lucaslannes/super_scaffold/main/assets/README/super_scaffold_landscape.png)

All properties of Scaffold can be applied in SuperScaffold, like `appBar`, `body`, `floatingActionButton` and so on.

## Show/hide drawer icon automatically

Use the SuperAppBar instead of Flutter AppBar if you need to display the drawer icon on portrait and hide it on landscape automatically.

```dart
@override
Widget build(BuildContext context) {
    return SuperScaffold(
        appBar: SuperAppBar(),
        drawer: Drawer(),
    );
}
```

All properties of AppBar can be applied in SuperAppBar, like `title`, `actions`, `backgroundColor` and so on.

## Pin the AppBar on the top of screen

If you're navigating between some pages and want to pin the AppBar on the top of screen, just insert them inside a Hero widget.

```dart
@override
Widget build(BuildContext context) {
    return SuperScaffold(
        appBar: Hero(
            tag: "tag",
            child: AppBar(),
        )
        drawer: Drawer(),
    )
}
```

If one AppBar has an TabBar on the bottom property, follow theses steps:

1. Replace State with `SuperState` on your StatefulWidget that owns the TabBar.
2. Override the getter `tabsLength` from SuperState and insert the correct number of tabs.
3. Add the `tabController` from SuperState inside your TabBar and the TabBarView.

```dart
class _PageState extends SuperState<Page> {
    @override
    int get tabsLength => 3;

    @override
    Widget build(BuildContext context) {
        return SuperScaffold(
            appBar: Hero(
                tag: "tag",
                child: AppBar(
                    bottom: TabBar(
                        controller: tabController,
                        ...
                    ),
                ),
            ),
            drawer: Drawer(),
            body: TabBarView(
                controller: tabController,
                ...
            ),
        );
    }
}
```

## Show confirmation dialog

First, replace State with SuperState on your StatefulWidget that will display the confirmation dialog.

Then, call the asynchronous method `confirm` from the `scaffold` property of the SuperState.

```dart
class _PageState extends SuperState<Page> {
    @override
    Widget build(BuildContext context) {
        return SuperScaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                    bool ok = await scaffold!.confirm("Do you want to continue?");
                },
            ),
        );
    }
}
```

## Show loading screen

First, replace State with SuperState on your StatefulWidget that will display the loading screen.

Then, call the method `wait` from the `scaffold` property of the SuperState.

```dart
class _PageState extends SuperState<Page> {
    @override
    Widget build(BuildContext context) {
        return SuperScaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.refresh),
                onPressed: () async {
                    Completer loading = scaffold!.wait();

                    await Future.delayed(Duration(milliseconds: 1500));

                    loading.complete();
                },
            ),
        );
    }
}
```

## Custom confirmation dialog and loading screen

The SuperScaffold widget uses the default AlertDialog of Flutter to display the confirmation dialog and the loading screen is just a centered CircularProgressIndicator.

Design your custom confirmation dialog and loading screen with the `confirmationBuilder` and the `loadingBuilder`, respectivately.

```dart
@override
Widget build(BuildContext context) {
    return SuperScaffold(
        drawer: Drawer(),
        confirmationBuilder: (context, confirmationMessage) {
            return ...
        },
        loadingBuilder: (context) {
            return ...
        }
    );
}
```

## Do you found an issue, have some question or maybe want to contribute?

Feel free to contact me through GitHub repository.

God bless you.