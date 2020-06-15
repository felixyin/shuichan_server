package org.nutz.j2cache.shiro;

import net.oschina.j2cache.CacheChannel;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.cache.CacheException;

import java.util.*;

/**
 * 封装j2cache为shiro的Cache接口
 * @author wendal
 */
@SuppressWarnings("unchecked")
public class  ShiroJ2Cache<K, V> implements Cache<K, V> {
	
	protected String region;
	
	protected CacheChannel channel;
	
	public ShiroJ2Cache(String region, CacheChannel channel) {
		this.region = region;
		this.channel = channel;
	}

	@Override
    public V get(K key) throws CacheException {
		return (V) this.channel.get(region, key.toString()).getValue();
	}

	@Override
    public V put(K key, V value) throws CacheException {
		this.channel.set(region, key.toString(), value);
		return null;
	}

	@Override
    public V remove(K key) throws CacheException {
		this.channel.evict(region, key.toString());
		return null;
	}

	@Override
    public void clear() throws CacheException {
		this.channel.clear(region);
	}

	@Override
    public int size() {
		return this.channel.keys(region).size();
	}

	@Override
    public Set<K> keys() {

		return new HashSet<K>((Collection<K>)this.channel.keys(region));
	}

	@Override
    public Collection<V> values() {
		List<V> list = new ArrayList<V>();
		for (K k : keys()) {
			list.add(get(k));
		}
		return list;
	}

}
