import { NativeEventEmitter, NativeModules } from 'react-native';

const { LocalSearchManager } = NativeModules;

const LocalSearchEventEmitter = new NativeEventEmitter(LocalSearchManager);

export type SearchLocationResultItem = {
  title: string;
  subtitle: string;
};

export type Coodinate = {
  latitude: number;
  longitude: number;
};

export const searchLocations = async (text: string) => {
  await LocalSearchManager.searchLocations(text);
};

export const updatedLocationResultsListener = (
  listener: (event: SearchLocationResultItem[]) => Promise<void> | void
) => {
  const emitterSubscription = LocalSearchEventEmitter.addListener(
    'onUpdatedLocationResults',
    listener
  );

  return emitterSubscription;
};

export const searchCoodinate = async (query: string): Promise<Coodinate> => {
  const result = await LocalSearchManager.searchCoodinate(query);
  return result;
};
