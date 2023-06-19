# react-native-mk-local-search

Native module for using MKLocalSearch with react native.

This library cannot be run on Android.

## Installation

```sh
yarn add react-native-mk-local-search
```

```sh
cd ios && pod install
```

## Usage

```tsx
import {
  searchCoodinate,
  searchLocations,
  updatedLocationResultsListener,
  Coodinate,
  SearchLocationResultItem,
} from 'react-native-mk-local-search';

// ...

export default function App() {
  const [results, setResults] = useState<SearchLocationResultItem[]>([]);
  const [coodinate, setCoodinate] = useState<null | Coodinate>(null);

  useEffect(() => {
    // The results of searchLocations are passed to this listener.
    const subscription = updatedLocationResultsListener((data) => {
      setResults(data);
    });

    return () => {
      subscription.remove();
    };
  }, []);

  const onChangeText = async (text: string) => {
    // Pass search keywords to searchLocations.
    await searchLocations(text);
  };

  const onItemPress = async (title: string, subtitle: string) => {
    try {
      // Get latitude and longitude from addresses and other queries.
      let searchedCoodinate = await searchCoodinate(subtitle);

      if (!searchedCoodinate) {
        searchedCoodinate = await searchCoodinate(`${title} ${subtitle}`);
      }

      setCoodinate(searchedCoodinate);
    } catch (e) {
      // If coodinate is not found, error occurs with [Error: Coodinate is not found].
      console.log(e);
    }
  };

  return (
    <View style={styles.container}>
      <TextInput style={styles.input} onChangeText={onChangeText} />

      <ScrollView
        style={styles.scroll}
        contentContainerStyle={styles.scrollContainer}
      >
        {results.map((result, index) => {
          return (
            <TouchableOpacity
              onPress={() => {
                onItemPress(result.title, result.subtitle);
              }}
              key={index}
              style={styles.itemContainer}
            >
              <Text style={styles.title}>{result.title}</Text>
              <Text style={styles.subtitle}>{result.subtitle}</Text>
            </TouchableOpacity>
          );
        })}
      </ScrollView>

      {!!coodinate && (
        <Text style={styles.coodinate}>
          {`latitude is ${coodinate.latitude}, longitude is ${coodinate.longitude}`}
        </Text>
      )}
    </View>
  );
}
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
